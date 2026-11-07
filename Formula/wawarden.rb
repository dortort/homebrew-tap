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
      url "https://github.com/dortort/wawarden/releases/download/v1.4.0/wawarden_v1.4.0_darwin_arm64"
      sha256 "42cb3d282b7acb395cc3d39d2221acb6056badfa324166cb060d566e66757287"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.4.0/wawarden_v1.4.0_darwin_amd64"
      sha256 "282f1166f15b9bdd8f932e5298eeaaadb2a7a2355f82a4186d7d879f515c72cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dortort/wawarden/releases/download/v1.4.0/wawarden_v1.4.0_linux_arm64"
      sha256 "8c77f55f81727636d5c58dc504c0777691703704c839f690bf93acd0a0c11ab1"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.4.0/wawarden_v1.4.0_linux_amd64"
      sha256 "743324433bffeb543c5aed0d6c0236024c36c1d76e5f687e703d5171ae46bb2d"
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
