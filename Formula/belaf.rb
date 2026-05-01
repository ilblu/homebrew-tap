class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "2.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.1/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "59c810c5aac2aad7ac8304d0c4d9f479bd7eb1ecb17d58da9ea098e4256a0c43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.1/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "4e5f7c98c957835132b0687847640e37b295ff1ed2b8af435113ae1f6ed79736"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.1/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe8cd6f8f230e5e511f575154d362a4d37b19d32d9641ac6874577adf0cc7a52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.1/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "36fa229ca545655d001908c6a58cbbe9dd458809cbac3723b729412161bb307c"
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
