class Ranking
  require "facets/math"

  ACTIVITY_LOWER_LIMIT = 15

  attr_accessor :user

  def initialize(user, prs:)
    @user = user
    @prs = prs
  end

  def total_pr_count
    prs.size
  end

  def eligible_pr_count
    eligible_prs.size
  end

  def problem_ratio
    @_problem_ratio ||= problematic_count / eligible_pr_count.to_f
  end

  def quick_fix_ratio
    @_quick_fix_ratio ||= quick_fix_count / eligible_pr_count.to_f
  end

  def problematic_count
    @_problematic_count ||= prs.count(&:problematic?)
  end

  def quick_fix_count
    @_quick_fix_count ||= prs.count(&:quick_fix?)
  end

  def long_running_count
    @_long_running_count ||= prs.count(&:long_running?)
  end

  def heavily_commented_count
    @_heavily_commented_count ||= prs.count(&:heavily_commented?)
  end

  def inactive?
    eligible_pr_count < ACTIVITY_LOWER_LIMIT
  end

  # Metrics

  def comment_count
    @_comment_count ||= calculate_metric(:comment_count)
  end

  def merge_time
    @_merge_time ||= calculate_metric(:merge_time)
  end

  private

    attr_accessor :prs

    def calculate_metric(metric)
      Math.median eligible_prs.map(&metric)
    end

    def eligible_prs
      @_eligible_prs ||= prs.reject(&:quick_fix?)
    end
end
