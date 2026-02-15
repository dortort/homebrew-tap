# typed: false
# frozen_string_literal: true

class Dgossgen < Formula
  desc "Generate dgoss-ready test suites from Dockerfiles"
  homepage "https://github.com/dortort/dgossgen"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dortort/dgossgen/releases/download/v0.1.0/dgossgen-aarch64-apple-darwin.tar.gz"
      sha256 "a33f2abae04627f1d448c06e647a0c9f63582aab02260bf62af2d1ea4cdd589d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dortort/dgossgen/releases/download/v0.1.0/dgossgen-x86_64-apple-darwin.tar.gz"
      sha256 "cba8067ccba5f9408738782ad04229bf69e15c7e577360ccab6ecd419ae79bb3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/dortort/dgossgen/releases/download/v0.1.0/dgossgen-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "403b49fde54483406a7834b52f97d846c340672f86e35018745c7e72dfe02982"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dortort/dgossgen/releases/download/v0.1.0/dgossgen-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a5d97c80d289055b2718912181e27208ee634ec40ad35584be71e2a7abc6bc34"
    end
  end

  def install
    bin.install "dgossgen"
  end

  test do
    system "#{bin}/dgossgen", "--version"
  end
end
