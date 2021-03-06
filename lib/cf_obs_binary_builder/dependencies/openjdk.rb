class CfObsBinaryBuilder::Openjdk < CfObsBinaryBuilder::SCMDependency
  attr_reader :minor_version, :update_version, :build_number, :full_version

  def initialize(version)
    full_version = version
    @minor_version, @update_version, @build_number = version.match(/jdk(\d)u(\d+)-b(\d+)/).captures
    super(
      "openjdk",
      "1.#{minor_version}.0_#{update_version}",
      {
        scm_type: "mercurial",
        url: "http://hg.openjdk.java.net/jdk8u/jdk8u",
        tag: version
      }
    )
  end

  def prepare_sources
    log "Download ca bundle..."
    system("curl -L https://curl.haxx.se/ca/cacert.pem  > cacerts.pem")

    log "Cloning the openjdk repository..."
    system("hg clone http://hg.openjdk.java.net/jdk8u/jdk8u")
    Dir.chdir "jdk8u" do
      system("chmod +x common/bin/hgforest.sh configure get_source.sh")
      system("./get_source.sh")
      system("./common/bin/hgforest.sh checkout #{full_version}")
    end

    log "Creating tarball..."
    system("tar --exclude=\.hg -czf #{version}.tar.gz jdk8u")
  end
end
