class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "3.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.2/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "95ffbf7e0b94fbe5c911336471b874e090576cb38432ba9cb942e2fdf444387d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.2/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "fb11eddbec448fc5af8c0478f65f2cddf8dae8ffd4eecaac9afe0945be8a6d86"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.2/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ef791c63bc94ab1473e746951fb46c4993e6059156c8b9dd5a24f3c2605da86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v3.0.2/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40f984574965d176a3a82a621ad550651cb2ad39631904919c8b33f0f12b4087"
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
