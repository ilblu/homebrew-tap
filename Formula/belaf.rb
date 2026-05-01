class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "3.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "6a6e07fd8b25eb6d97d1bc23940f51d89280c8d9181b982d48abf04cc932c0c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "fdc259072222baf2e8b86f6319d6f8309e4bc4569a13c42fca47c14058f35982"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f4454f52bb10cfdb542d7a4bf4568613c2fc15bcef39fa4e585f852e0303cc70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ed8c9ee3086fd866807bd800ed6ad9861d2f09ad9e890fcd1caaf29ae815b07"
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
