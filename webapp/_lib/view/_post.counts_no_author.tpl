{*
Render a post without an author and with replies or retweet counts.

Included in multiple plugin templates which render lists of posts.

Parameters:
$post (required) Post object
$scrub_reply_username (optional) If set or not false, scrub the @reply username from the post_text
$show_favorites_instead_of_retweets (optional) If set or not false, show favorites instead of retweet counts.
*}

{if $smarty.foreach.foo.first}
  <div class="header clearfix">
    <div class="grid_13 alpha">&#160;</div>
    <div class="grid_2 center">
      {if $post->network eq 'twitter'}{if $show_favorites_instead_of_retweets}favorites{else}retweets{/if}{/if}
    </div>
    <div class="grid_2 center omega">
      replies
    </div>
  </div>
{/if}

<div class="clearfix">
  <div class="individual-tweet post clearfix{if $post->is_protected} private{/if}">
    <div class="grid_13">
      <div class="post">
        {if $post->post_text}
          {if $scrub_reply_username}
            {$post->post_text|filter_xss|regex_replace:"/^@[a-zA-Z0-9_]+/":""|link_usernames_to_twitter}
          {else}
            {$post->post_text|filter_xss|link_usernames_to_twitter}
          {/if}
        {/if}
      {if $post->link->expanded_url}
      <br>
        {if $post->link->is_image}
         <div class="pic" style="float:left;margin-right:5px;margin-top:5px;"><a href="{$post->link->url}"><img src="{$post->link->expanded_url}" style="margin-bottom:50px;"/></a></div>
        {/if}
         <span class="small"><a href="{$post->link->url}" title="{$post->link->expanded_url}">{if $post->link->title}{$post->link->title}{else}{$post->link->url}{/if}</a>
        {if $post->link->description}<br><small>{$post->link->description}</small>{/if}</span>
      {/if}


        {if !$post && $post->in_reply_to_post_id }
          <a href="{$site_root_path}post/?t={$post->in_reply_to_post_id}"><span class="ui-icon ui-icon-arrowthick-1-w" title="reply to..."></span></a>
        {/if}
      {if $post->link->expanded_url and !$post->link->is_image and ($post->link->expanded_url != $post->link->url)}
        <span class="small">
          <a href="{$post->link->url}" title="{if $post->link->title}{$post->link->title}{/if}">{if $post->link->title}{$post->link->title}{else}{$post->link->expanded_url}{/if}</a>
          {if $post->link->description}<br>{$post->link->description}{/if}
        </span>
      {/if}
      <div class="small gray">
        <span class="metaroll">
        <a href="{$site_root_path}post/?t={$post->post_id}&n={$post->network}">{$post->adj_pub_date|relative_datetime} ago</a>
        {if $post->is_geo_encoded < 2}
        from {$post->location|truncate:60:' ...'}
       {/if}
        {if $post->network == 'twitter'}
        <a href="http://twitter.com/intent/tweet?in_reply_to={$post->post_id}"><span class="ui-icon ui-icon-arrowreturnthick-1-w" title="reply"></a>
        <a href="http://twitter.com/intent/retweet?tweet_id={$post->post_id}"><span class="ui-icon ui-icon-arrowreturnthick-1-e" title="retweet"></a>
        <a href="http://twitter.com/intent/favorite?tweet_id={$post->post_id}"><span class="ui-icon ui-icon-star" title="favorite"></a>
        {/if}
      </span>&nbsp;</div>
      </div><!--end post-->
      
    </div>
    <div class="grid_2 center">
    {if $post->network eq 'twitter'}
     {if $show_favorites_instead_of_retweets && $show_favorites_instead_of_retweets != false}
       {if $post->favd_count}
       <span class="reply-count">
          <a href="{$site_root_path}post/?t={$post->post_id}&n={$post->network}&v=favs">{$post->favd_count}</a>
       </span>
      {else}
        &#160;
      {/if}
    {else}
      {if $post->all_retweets > 0}
        <span class="reply-count">
        <a href="{$site_root_path}post/?t={$post->post_id}&n={$post->network}&v=fwds">{$post->all_retweets|number_format}{if $post->rt_threshold}+{/if}<!-- retweet{if $post->retweet_count_cache eq 1}{else}s{/if}--></a>
        </span>
      {else}
        &#160;
      {/if}
      {/if}
    {/if}
    </div>
    <div class="grid_2 center omega">
      {if $post->reply_count_cache > 0}
        <span class="reply-count">
        <a href="{$site_root_path}post/?t={$post->post_id}&n={$post->network}">{$post->reply_count_cache}<!-- repl{if $post->reply_count_cache eq 1}y{else}ies{/if}--></a>
        </span>
      {else}
        &#160;
      {/if}
    </div>
  </div>
</div>