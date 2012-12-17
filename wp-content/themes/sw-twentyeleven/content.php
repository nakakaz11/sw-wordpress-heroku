<?php
/**
 * The default template for displaying content
 *
 * @package WordPress
 * @subpackage Twenty_Eleven
 * @since Twenty Eleven 1.0
 */
?>
<!--content.php-->
	<article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
		<header class="entry-header">
			<?php if ( is_sticky() ) : ?>
				<hgroup>
					<h2 class="entry-title"><a href="<?php the_permalink(); ?>" title="<?php printf( esc_attr__( 'Permalink to %s', 'twentyeleven' ), the_title_attribute( 'echo=0' ) ); ?>" rel="bookmark"><?php the_title(); ?></a></h2>
					<h3 class="entry-format"><?php _e( 'Featured', 'twentyeleven' ); ?></h3>
				</hgroup>
			<?php else : ?>
			<h1 class="entry-title"><a href="<?php the_permalink(); ?>" title="<?php printf( esc_attr__( 'Permalink to %s', 'twentyeleven' ), the_title_attribute( 'echo=0' ) ); ?>" rel="bookmark"><?php the_title(); ?></a></h1>
			<?php endif; ?>
			<?php if ( 'post' == get_post_type() ) : ?>
			<div class="entry-meta">
				<?php twentyeleven_posted_on(); ?>
			</div><!-- .entry-meta -->
			<?php endif; ?>

			<?php if ( comments_open() && ! post_password_required() ) : ?>
			<div class="comments-link">
				<?php comments_popup_link( '<span class="leave-reply">' . __( 'Reply', 'twentyeleven' ) . '</span>', _x( '1', 'comments number', 'twentyeleven' ), _x( '%', 'comments number', 'twentyeleven' ) ); ?>
			</div>
			<?php endif; ?>
		</header><!-- .entry-header -->

		<?php if ( is_search() ) : // Only display Excerpts for Search ?>
		<div class="entry-summary">
			<?php the_excerpt(); ?>
		</div><!-- .entry-summary -->
		<?php else : ?>
		<div class="entry-content">
      <!-- SW meta 挿入 -->
      <?php
      $exmetaSW1 = new CustomMetaTable1;  // 移してきた
      $get_metaSW1 = $exmetaSW1->get_meta1($post->ID);  //Call to a member function get_meta() on a non-object
      $item_name = isset($get_metaSW1->text) ? $get_metaSW1->text : null;
      $misc =      isset($get_metaSW1->misc) ? $get_metaSW1->misc : null;
      if (($item_name != "")||($misc != "") ){
        echo ("<h2 class='swCalHead'>SW Calorie ToDo_1（admin）</h2>");
        echo ("<span class='swCaltxt'>");
        echo strip_tags($item_name,'<a>');
        echo ("</span><br>");
        echo ("<span class='swCaltxt'>");
        echo strip_tags($misc,'<a>');
        echo (" kCal</span><br>");
      } else {
        echo ("<h2 class='swCalHeadNot'>SW Calorie ToDo_1（admin）＊Not Registered</h2>");
      }
      ?>
      <hr>
      <?php
      $exmetaSW2 = new CustomMetaTable2;  // 移してきた
      $get_metaSW2 = $exmetaSW2->get_meta2($post->ID);
      $item_name = isset($get_metaSW2->text) ? $get_metaSW2->text : null;
      $misc =      isset($get_metaSW2->misc) ? $get_metaSW2->misc : null;
      if (($item_name != "")||($misc != "") ){
        echo ("<h2 class='swCalHead'>SW Calorie ToDo_2（github）</h2>");
        echo ("<span class='swCaltxt'>");
        echo strip_tags($item_name,'<a>');
        echo ("</span><br>");
        echo ("<span class='swCaltxt'>");
        echo strip_tags($misc,'<a>');
        echo (" kCal</span><br>");
      } else {
        echo ("<h2 class='swCalHeadNot'>SW Calorie ToDo_2（github）＊Not Registered</h2>");
      }
      ?>
      <hr>
      <p></p>
      <!-- SW meta 挿入 -->
			<?php the_content( __( 'Continue reading <span class="meta-nav">&rarr;</span>', 'twentyeleven' ) ); ?>
			<?php wp_link_pages( array( 'before' => '<div class="page-link"><span>' . __( 'Pages:', 'twentyeleven' ) . '</span>', 'after' => '</div>' ) ); ?>
		</div><!-- .entry-content -->
		<?php endif; ?>
		<footer class="entry-meta">
			<?php $show_sep = false; ?>
			<?php if ( 'post' == get_post_type() ) : // Hide category and tag text for pages on Search ?>
			<?php
				/* translators: used between list items, there is a space after the comma */
				$categories_list = get_the_category_list( __( ', ', 'twentyeleven' ) );
				if ( $categories_list ):
			?>
			<span class="cat-links">
				<?php printf( __( '<span class="%1$s">Posted in</span> %2$s', 'twentyeleven' ), 'entry-utility-prep entry-utility-prep-cat-links', $categories_list );
				$show_sep = true; ?>
			</span>
			<?php endif; // End if categories ?>
			<?php
				/* translators: used between list items, there is a space after the comma */
				$tags_list = get_the_tag_list( '', __( ', ', 'twentyeleven' ) );
				if ( $tags_list ):
				if ( $show_sep ) : ?>
			<span class="sep"> | </span>
				<?php endif; // End if $show_sep ?>
			<span class="tag-links">
				<?php printf( __( '<span class="%1$s">Tagged</span> %2$s', 'twentyeleven' ), 'entry-utility-prep entry-utility-prep-tag-links', $tags_list );
				$show_sep = true; ?>
			</span>
			<?php endif; // End if $tags_list ?>
			<?php endif; // End if 'post' == get_post_type() ?>

			<?php if ( comments_open() ) : ?>
			<?php if ( $show_sep ) : ?>
			<span class="sep"> | </span>
			<?php endif; // End if $show_sep ?>

			<span class="comments-link"><?php comments_popup_link( __( 'Leave a reply', 'twentyeleven' ), __( '<b>1</b> Reply', 'twentyeleven' ), __( '<b>%</b> Replies', 'twentyeleven' ) ); ?></span>

			<?php endif; // End if comments_open() ?>

			<?php edit_post_link( __( 'Edit', 'twentyeleven' ), '<span class="edit-link">', '</span>' ); ?>
		</footer><!-- #entry-meta -->
	</article><!-- #post-<?php the_ID(); ?> -->
