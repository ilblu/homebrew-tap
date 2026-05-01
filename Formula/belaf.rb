class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "3.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.1/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "2ef0dafdcd789cd883b132590b913f62d62d6774b5d5a305f0cc1fbda4a809d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.1/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "e779243388d7852e476e02e5837586d616ded3cc953c46832aab85415e884f70"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.1/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8590efcd035fa681fcc7bd7ce3c440b152522179b7af341a6875da2ed715870d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.1/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "88ec28b024d6e94160876ef20461c410feb1a14ad058fe2fb7c4b7b9dd1acf9c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "belaf" if OS.mac? && Hardware::CPU.arm?
    bin.install "belaf" if OS.mac? && Hardware::CPU.intel?
    bin.install "belaf" if OS.linux? && Hardware::CPU.arm?
    bin.install "belaf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
