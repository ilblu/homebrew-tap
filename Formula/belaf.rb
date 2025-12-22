class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.2.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "3f480dd0d688b71971aa3c362f345f5932cd634e8976b33bf97c95cef08ec115"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.2.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "ba08fec8e1120e66b67d8df3c13f50b74d5c6e56ad4f13f0d8c5c09274b8196e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.2.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e539004672e3c0b6b0bfcf01e4de98b78dac45d9635262fe11cfe09955800f2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.2.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bc2d287bfca83a3adb173eb17f217dc5d326ec198b9e01c65214c3e5955794af"
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
