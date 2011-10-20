module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  private
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      # use [nil, nil] to prevent cookies from spurious test breakage
      # since support of signed cookies in Rails is not mature?
      cookies.signed[:remember_token] || [nil, nil]
    end

    def current_user?(user)
      user == current_user
    end

    def deny_access
      redirect_to signin_path, :notice => "Please sign in to access the page"
    end

    def deny_and_redirect_to_root
      redirect_to root_path, :notice => "Access other user's profile is not allowed"
    end
end
