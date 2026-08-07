class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "3.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.1.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "874e7ac755b7c9a919cb7253ec9076eff24ab2e34ed9209644cc2c885c140aec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.1.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "56c56badee0644107fdd633123c814671f0548b16747a1727912e73dbb6caf66"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.1.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "70632fae79a46af4d30e5d284ed83253f17cba080cad85a0b67e92ebab614a17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.1.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d8b4fa449387cc04954f2dccadfb0ba6cc1833b2f7c8e8ca068916d9014f4fc"
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
