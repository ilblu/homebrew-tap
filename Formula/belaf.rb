class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "1.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.1/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "4fe03bffd3b714bc566c466fb44fad8c62ac179ff46d7fb62dc22379ab4892a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.1/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "03ea56c21b2c5796ac5f0fd99299ed9e04c75974c1ee9913add385c0ea3f6980"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.1/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "80df7181afbbbb3e3a17bc761bcacabd7be28d2ab7769965faa772f8a343b50c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.1/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a04ffff3f42d1353ab9cea9f7f186a1a0a44b2e00225dc1c70064c276c1fd59b"
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
