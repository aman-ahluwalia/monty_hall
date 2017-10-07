class ApiVersion
  def initialize(version)
    @version = version
  end

  def matches?(request)
    versioned_accept_header?(request)
  end

  private

  def versioned_accept_header?(request)
    accept = request.headers['Api-Version']
    accept && accept[/application\/vnd\.examproject-v#{@version}\+json/]
  end

end