class Wawarden < Formula
  desc "Self-hosted WhatsApp gateway with per-client, per-chat access for AI agents"
  homepage "https://github.com/dortort/wawarden"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/dortort/wawarden/releases/download/v1.4.1/wawarden_v1.4.1_darwin_arm64"
      sha256 "db12b3acc63f8151be4ae96a5c279d6440ef28b806d769ea53bddb5bce2cb004"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.4.1/wawarden_v1.4.1_darwin_amd64"
      sha256 "79fcd4b1ea82878878d6f5443034503dd425f829e6f0bde80837176a80147f81"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dortort/wawarden/releases/download/v1.4.1/wawarden_v1.4.1_linux_arm64"
      sha256 "ef0ef5d6d169b00ed0815f67c7bbfbaab073abc5acc915dfe3a138ebb8922b5f"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.4.1/wawarden_v1.4.1_linux_amd64"
      sha256 "1289ca3fb3790415d4bc961f0cd7f312a6b973e5666e52c0ddef16c81b3c63ac"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "wawarden_v#{version}_#{os}_#{arch}" => "wawarden"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      On macOS, wawarden serve needs WAWARDEN_DATA_DIR: its default, /data,
      does not exist there. macOS is supported for the commands run away from
      the service, such as backup verify, and for evaluation; the deployment
      guidance is for Linux only. See:
        https://wawarden.dortort.dev/getting-started/#macos
    EOS
  end

  test do
    lines = shell_output("#{bin}/wawarden version").lines(chomp: true)
    assert_equal "wawarden v#{version}", lines.first
    assert_equal "dev build false", lines.last
  end
end
