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
      url "https://github.com/dortort/wawarden/releases/download/v1.2.0/wawarden_v1.2.0_darwin_arm64"
      sha256 "c1abcc60497da9314ddb13afa61d2ff8f7cb230fd8999928ce33a45777378879"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.2.0/wawarden_v1.2.0_darwin_amd64"
      sha256 "30b1a221648cf8c3b9e3ce052e4a5bd99e11765be1a22a95b415a7948c9e26d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dortort/wawarden/releases/download/v1.2.0/wawarden_v1.2.0_linux_arm64"
      sha256 "909bbcf7cc914490ec74388e64bda316ae0d8f6865f43366b4095ba42af9124e"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.2.0/wawarden_v1.2.0_linux_amd64"
      sha256 "e7cd9dc11f6056f8073e27a6aa8d75754e7846441041a72044988c3820ecc6aa"
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
