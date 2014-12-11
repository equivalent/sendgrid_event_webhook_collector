require 'forwardable'
class Auth
  extend Forwardable

  def_delegator :context, :current_user
  attr_accessor :policy
  attr_accessor :action
  attr_accessor :resource

  def initialize(context)
    @context = context
  end

  def authenticate!
    context.error!('401 Unauthorized', 401) unless current_user
  end

  def authorize!
    unless policy.new(current_user, resource).send(action)
      context.error!('403 Forbidden', 403)
    end
  end

  private
  attr_reader :context

end
