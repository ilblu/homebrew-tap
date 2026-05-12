class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "1.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.1/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "6c5775560012c7ae8402e480f85499e2d37a9308071ce84db51db41728c18595"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.1/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "91573cbd02453f425244d80551046741818cb21bf1d0bb09d8b63ce5ba80a00a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.1/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "980e5b3beb0d5a3b74bdce32e63cb0bef9aeb3fadf3f524af0810d43b6801cbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.1/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3f75579d55b0277491b7d8e630ba049e4d57a31be9364c2027129e7230566983"
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
