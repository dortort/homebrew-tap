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
      url "https://github.com/dortort/wawarden/releases/download/v1.2.3/wawarden_v1.2.3_darwin_arm64"
      sha256 "5c405368d62913ce4cf89595649f48333892a01cab19908e392b480bf8881109"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.2.3/wawarden_v1.2.3_darwin_amd64"
      sha256 "2ff641c6e20bb6478dfecb0418eeb9b0ae2cb1f3cb8c2f3a1fff7305f1f6d40b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dortort/wawarden/releases/download/v1.2.3/wawarden_v1.2.3_linux_arm64"
      sha256 "7eb88bc6e5e6c3c05f5b9b0b4c9b7db42a363d918fc72eddaa7235b66cc3acac"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.2.3/wawarden_v1.2.3_linux_amd64"
      sha256 "ba9b91694715bddd1b029b63dde6f688a3d275ecb7735d481ef1a034eb3c73d0"
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
