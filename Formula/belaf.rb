class Belaf < Formula
  desc "Release management CLI for monorepos"
  homepage "https://github.com/ilblu/belaf"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.1.0/belaf-aarch64-apple-darwin.tar.xz"
      sha256 "dcad0815d8c1dfe3fc32889d8ce42214582cf73113383f2790000e1890d80d48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.1.0/belaf-x86_64-apple-darwin.tar.xz"
      sha256 "2232b46d6b5d2fb2790b4a1f87845436ae227f190e49a2ad37ed773d4ad6de63"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilblu/belaf/releases/download/v1.1.0/belaf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df8e94e22309d20a4c89cb7dac3108bc9ae8a9f5e15307a0dcedae606a2c6acf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilblu/belaf/releases/download/v1.1.0/belaf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1f83a98b414791ee15e7f3a4353ea1a79b721ae52d00330392dde023e1566a7f"
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

  def caveats
    <<~EOS

      ╔══════════════════════════════════════════════════════════════╗
      ║                                                              ║
      ║   🚀 belaf has been installed successfully!                  ║
      ║                                                              ║
      ║   Get started:                                               ║
      ║     belaf init        Initialize your repository             ║
      ║     belaf status      View release status                    ║
      ║     belaf prepare     Prepare a new release                  ║
      ║                                                              ║
      ║   Need help?                                                 ║
      ║     belaf --help      Show all commands                      ║
      ║     https://github.com/ilblu/belaf                           ║
      ║                                                              ║
      ╚══════════════════════════════════════════════════════════════╝

    EOS
  end
end
