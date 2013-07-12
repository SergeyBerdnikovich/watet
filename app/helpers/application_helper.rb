module ApplicationHelper
  def get_avatar
    ava = current_user.try(:profile).try(:avatar)
    ava = '/assets/maket/no_avatar.png' if ava.blank?
    image_tag ava
  end

  def show_page(name, with_title = false, with_latest_update = false)
    page = StaticPage.find_by_name(name)
    page ? text = page.content : page = StaticPage.create!(:name => name)
    text.blank? ? text = "<p>There is no text available. If you are admin, please add it #{ link_to 'here', edit_admin_static_page_path(page) }.</p>" : text
    text = "Last update: #{page[:updated_at].strftime("%Y-%m-%d")} <p> #{text}" if with_latest_update
    text = "<center><h2>#{page[:title]}</h2></center> <p> #{text}" if with_latest_update

    text
  end

  def link_to_page(name)
    page = StaticPage.find_by_name(name)
    page = StaticPage.create!(:name => name) unless page
    static_page_path(page)
  end

  def list_item_title_url(list_item)
    if list_item.url.present? && list_item.url =~ /^http:\/\/[a-z0-9.\/@A-Z?=-]+/
      link_to list_item.title, list_item.url, :target => "_blank"
    elsif list_item.url.present?
      link_to(list_item.title, 'http://' + list_item.url, :target => "_blank")
    elsif list_item.title =~ /^http:\/\/[a-z0-9.\/@A-Z?=-]+/ || list_item.title =~ /^www.[a-z0-9.\/@A-Z?=-]+/
      link_to list_item.title, list_item.title, :target => "_blank"
    else
      list_item.title
    end
  end

  def list_item_url(list_item)
    if list_item.url.present? && list_item.url =~ /^http:\/\/[a-z0-9.\/@A-Z?=-]+/
      link_to list_item.url, list_item.url, :target => "_blank"
    elsif list_item.url.present?
      link_to(list_item.url, 'http://' + list_item.url, :target => "_blank")
    else
      nil
    end
  end

  def list_item_desc(list_item)
    if list_item.description
      regexp = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/
      list_item.description.gsub(regexp).each do |result|
        if result =~ /^http:\/\/[a-z1-9.\/@A-Z?=]+/
          "<a href=#{result}>#{result}</a>"
        else
          "<a href=#{'http://' + result}>#{result}</a>"
        end
      end
    end
  end

  def banner_image_url(banner)
    if banner.url.present? && banner.url =~ /^http:\/\/[a-z0-9.\/@A-Z?=-]+/
      link_to image_tag(banner.image), banner.url, :class => "banner_image"
    elsif banner.url.present?
      link_to image_tag(banner.image), 'http://' + banner.url, :class => "banner_image"
    else
      image_tag(banner.image)
    end
  end
end
