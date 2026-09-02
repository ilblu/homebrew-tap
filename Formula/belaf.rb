class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "5.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "cf4fec5f4761b5b8d3735661ffcfbb896517be68bf3fe11d8ea472f4209fa62e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "651d04bedda2ff70e870fff5345549df43e2f9cf38978fd6b32943ed2b37515c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6a95239846dbb5a81e4414b8ed6b90b545327a42d6b0ad3210da837a6059426"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v5.0.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "237b0d1bbe290e462dd04fedd13919f4a514e7dffc892cf1b8e3e30a64ec4b89"
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
