class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "4.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v4.0.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "096c44575ecfe4d94a306d2034ff59ebb69999b66348cabbd44f0fd264bdeabd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v4.0.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "e7c0f95f81f43c87d49c69877d84b733a404b826ae5ae62bef646b25fef25e55"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v4.0.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "549e1057b4e047ba99103286c6756fc57b49f917426e2da5187609f315fbfce4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v4.0.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1208b2a27de6b7fc7fe2509aec353f3b15c496b8dd50dcb948380171fcadd961"
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
