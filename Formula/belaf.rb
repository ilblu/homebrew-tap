class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "2.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v2.0.1/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "e8b437f1fbd70ec616ef0cb44ddc8351d08957143ae6dba8ecbdce5b4927cbab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v2.0.1/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "2574d79e041226911cb85a4dd101635412c5604fa0c4f9650e515a4b61de0a3e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v2.0.1/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6a1adb6b9caa994bc9dd4faf0ea1f0b2392570538cabe5fd3fcbad0cc8a21d67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v2.0.1/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42d5729191eee6346d38dbfe2ddc5fde1002f48467f440eb9dd650f19f228d7b"
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
