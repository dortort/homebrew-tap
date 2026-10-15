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
      url "https://github.com/dortort/wawarden/releases/download/v1.1.0/wawarden_v1.1.0_darwin_arm64"
      sha256 "cdfd760a0beb4b22b432b191b9b9dffdb3c013507ff379b7bebbd662aab84637"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.1.0/wawarden_v1.1.0_darwin_amd64"
      sha256 "ee6be8d3aca0173368e11d542d6894ab8b2ec15f8a9113e18bc50bd4ade5b98c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dortort/wawarden/releases/download/v1.1.0/wawarden_v1.1.0_linux_arm64"
      sha256 "aa2455ea980c871832da40bb5a8ba137479033e9783531add88792270c7da0c5"
    end
    on_intel do
      url "https://github.com/dortort/wawarden/releases/download/v1.1.0/wawarden_v1.1.0_linux_amd64"
      sha256 "b7ac022c262f296e134124b49a8e0614aa05fe36cebbcc83cc7127fa65d0011b"
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
