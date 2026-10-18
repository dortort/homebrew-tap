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
      url "https://github.com/dortort/wawarden/releases/download/v1.3.0/wawarden_v1.3.0_darwin_arm64"
      sha256 "d4cbfb5e939efccfb3ef94c2ff079e43c93bfff2dd50e983df573cd0a51f9d8d"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.3.0/wawarden_v1.3.0_darwin_amd64"
      sha256 "6c36e52c31baf664087e6f9ea08f1815f88f3a16d43add97a41caf21ba8be449"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dortort/wawarden/releases/download/v1.3.0/wawarden_v1.3.0_linux_arm64"
      sha256 "cd71bf6cda11aaed1216f5f6257317413cb8252b430d2db52da2b749f55965c8"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.3.0/wawarden_v1.3.0_linux_amd64"
      sha256 "86879b8f6c9765db352fe22a49145257970f2b4290f9a3530d210f24f528f244"
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
