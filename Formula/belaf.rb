class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "5.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.1/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "e911c3bd533030dad2097d12609caa2c05587fb3d786314d05217372cdc1d41b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.1/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "fd123ce552b22f6802843a7be3244874c7a00d5cb01c164cbf24ffefe50c17b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.1/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "17aaf78473f205d0d8c650c9cc793bec08a21067133a5c34275d386e790f4beb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.1/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "91180dab0cac2f7812b5c8d0e1350327a53784cae2751e7a620bf1af91eca248"
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
