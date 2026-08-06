class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "3.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "77f585b29c7d8d5bed1df9f7df2ab9065c04fc1eb54ef85e1fcb7171918ac442"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "114baa1835beeef003f8fd6a57dc33241de1ae9e4eebfbf37d6b44603f807972"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02bc1f9b33464ea4d81db935c285fdd09db04bce65ababef325d559a229ba85f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6da6a47cd804e6c7fb5a5c6cd4d7115790b8eb9ae1d94d6f92a7ce54295d9c68"
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
