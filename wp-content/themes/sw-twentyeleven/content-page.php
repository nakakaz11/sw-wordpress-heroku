<?php
/**
 * The template used for displaying page content in page.php
 *
 * @package WordPress
 * @subpackage Twenty_Eleven
 * @since Twenty Eleven 1.0
 */
?>
<!--content-page.php-->
<article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
	<header class="entry-header">
		<h1 class="entry-title"><?php the_title(); ?></h1>
	</header><!-- .entry-header -->
    <!--content-page.php-->
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
		<?php the_content(); ?>

		<?php wp_link_pages( array( 'before' => '<div class="page-link"><span>' . __( 'Pages:', 'twentyeleven' ) . '</span>', 'after' => '</div>' ) ); ?>
	</div><!-- .entry-content -->
	<footer class="entry-meta">
		<?php edit_post_link( __( 'Edit', 'twentyeleven' ), '<span class="edit-link">', '</span>' ); ?>
	</footer><!-- .entry-meta -->
</article><!-- #post-<?php the_ID(); ?> -->
