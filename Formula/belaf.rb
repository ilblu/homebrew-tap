class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "5.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v5.1.1/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "2522423f3c684c801a5df8ad16d3edc11606f319127d9a3ac96084c221dfe66f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v5.1.1/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "74b50183f3e76a75d7874d4ee7c8b829f7023b0b99f3e0f727544cd5442b3708"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v5.1.1/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2596e4e7abc720ef1652632eab25d8cd4afa60261bcbff2f005821eb30f255ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v5.1.1/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab4586207b9b36c2270b3a1ad9a558fa092d6bc79995562dc22fc4eabc047bde"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "belaf"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "belaf"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "belaf"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "belaf"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
