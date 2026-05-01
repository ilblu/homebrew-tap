class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "2.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "dd96ba3d2487c6da13d38e265be56246def2897da755eb7cfb4e19bb3d748594"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "df9cfc6d24eac2c03f33b359d7ed5c0494a4b06c7a91d90d8b262f3cab7c3acc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bbcf8f836c973dfe3b7bb54193ca2781ba7012ed515712a5f787c09af1921e8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c5f392c606b92591dd5ff5e77d641fc06585a3f7db86097950d062c61b006192"
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
