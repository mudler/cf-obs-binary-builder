class CfObsBinaryBuilder::Maven < CfObsBinaryBuilder::BaseDependency
  def initialize(version)
    super(
      "maven",
      version,
      "https://www.apache.org/dist/maven/maven-3/#{version}/source/apache-maven-#{version}-src.tar.gz"
    )
  end

  def prepare_sources
    super

    log "Caching maven dependencies..."
    working_dir = Dir.pwd
    Dir.mktmpdir do |dir|
      log `tetra init maven "#{working_dir}/apache-maven-#{version}-src.tar.gz"`
        Dir.chdir "maven" do
          log `tetra dry-run -s 'cd src/apache-maven-#{version};mvn -DdistributionTargetDir=#{dir} clean package'`
          Dir.chdir "src/apache-maven-#{version}" do
            log `tetra generate-all`
          end
          FileUtils.cp "packages/#{dependency}-kit/#{dependency}-kit.tar.xz", working_dir
        end
    end
  end

end
