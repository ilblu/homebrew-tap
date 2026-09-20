class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "5.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.2/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "4d3e59d8e52175b652b15c295c79360c20d0d25cfb7ad29c6f123474a14554fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.2/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "383cccabb4b3a7f9a3b44699e715eb381ba3aff31d50294c7b83d124320a5c5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.2/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0e5203bc3cfad07e0d29befdd7533031e7bb2c0e11ff5f81293c2bbca32d3a08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.2/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96a06886781af91f19c785b27fc40421b949d3173bb70ffb3bd2966b61b45f65"
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
