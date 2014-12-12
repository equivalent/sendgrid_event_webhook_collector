module CurrentUserHelpers
  def auth
    @auth ||= Auth.new(self)
  end

  def current_user
    @current_user ||= User.find_param(token)
  end

  def token
    headers['Authorization']
      .to_s
      .match(/Token\s+(.*)/) { |m| m[1] } \
      || params[:token]
  end
end
