class CfObsBinaryBuilder::Dotnetaspnetcore < CfObsBinaryBuilder::S3Dependency
  def initialize(version)
	# We would have also the hash in the URL
    super(
      'dotnet-aspnetcore',
      'dotnet',
      version,
      [/^1.*/]
    )
  end
end
