class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.0.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "a4cda856fd79f5235b1965afc817f6c8ca2099d606a2b9f28ecd0a492200dc71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.0.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "f32c3ba946cd4019bf6fd2bc9d1b9994ecca4b9f679a3ddf8ddd2689a3f46eba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.0.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2d12751c2888815eae0240675b3285f0617c617642eb11cfe43a2fa691c8393"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.0.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1fab60aad2fa253850c99c39145007491a1cd31e2ffeb58fb78acf5f9dcaf11e"
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
