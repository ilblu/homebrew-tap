class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "1d72747da49201477fb4e13135758f637debf4a4e6aa912c2f8a3f5937b63540"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "08437e160558e7eab5a360f878ba2fb97b6f38592a5eac7330026b0774e0cfca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f197a9ce9e95ccc4806aed2796874a9408706b8c03ad966a73a12b26c3f0efae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.3.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c3698e4774e8fac09792ba5e94687c6ec4f7cd48ed5781699afce8186767527"
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
