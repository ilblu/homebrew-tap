class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "2.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "f08191cae7e63fca7f3540b4acf18a4611da7c1f167572ee731f244747ffc735"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "3df813d834aee05805f68b96c2801a54e1cc3915089e5123a39afbdf84eb237a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6427262d2ce57c945e1ea85aa0108520ad8e587b716961c616ceb89c4d64a811"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v2.1.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "330cc0c8aa6ffc6b8aa6eed7f03eea5e25118b35af7ef223dd13fdb85115fee7"
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
