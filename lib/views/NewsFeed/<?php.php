<?php
require 'config.php';
$output = array();
$user_id;
$text;
$loc = "";
if ($conn) {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (isset($_POST['auth_key']) && $_POST['auth_key'] == $auth_key) {

            $user_id = $_POST['user_id'];
            $text = $_POST['text'];

            $query1 = "INSERT INTO `social_posts` (`id`, `user_id`, `text`, `visibility`, `status`, `type`, `ref_id`, `time_created`) 
                        VALUES (NULL, '$user_id', '$text', 'public', 'published', 'post', NULL, NULL)";
            if ($run1 = mysqli_query($conn, $query1)) {
                $last_id = $conn->insert_id;

                if (!empty($_FILES['image'])) {
                    $ext = explode(".", $_FILES['image']['name']);

                    $image = $ext[0] . $last_id . '_' . $user_id . '.' . end($ext);
                    $half_path = "files/users/user_" . $user_id . "/social/posts/files/" . $image;
                    $path = $_SERVER['DOCUMENT_ROOT'] . "/files/users/user_" . $user_id . "/social/posts/files/" . $image;
                    $tmp = $_FILES['image']['tmp_name'];


                    if (move_uploaded_file($tmp, $path)) {
                        $query1 = "INSERT INTO `social_files` (`id`, `user_id`, `object_id`, `object_type`, `url`, `type`) 
                    VALUES (NULL, '$user_id', '$last_id', 'post', '$half_path', 'image')";
                        if ($run1 = mysqli_query($conn, $query1)) {
                            $query2 = "INSERT INTO `social_files` (`id`, `user_id`, `object_id`, `object_type`, `url`, `type`) 
                        VALUES (NULL, '$user_id', '$last_id', 'post', '$half_path1', 'video')";
                            $run1 = mysqli_query($conn, $query2);
                        }
                    }
                }
                if (!empty($_FILES['video'])) {
                    $ext1 = explode(".", $_FILES['video']['name']);
                    if (end($ext1) == "mp4") {
                        $video = $ext1[0] . $last_id . '_' . $user_id . '.' . end($ext1);
                        $half_path1 = "files/users/user_" . $user_id . "/social/posts/files/" . $video;
                        $path1 = $_SERVER['DOCUMENT_ROOT'] . "/files/users/user_" . $user_id . "/social/posts/files/" . $video;
                        $tmp1 = $_FILES['video']['tmp_name'];

                        if (move_uploaded_file($tmp1, $path1)) {
                            $query2 = "INSERT INTO `social_files` (`id`, `user_id`, `object_id`, `object_type`, `url`, `type`) 
                        VALUES (NULL, '$user_id', '$last_id', 'post', '$half_path1', 'video')";
                            $run2 = mysqli_query($conn, $query2);
                        }
                    }
                }
                if (!empty($_FILES['audio'])) {
                    $ext2 = explode(".", $_FILES['audio']['name']);
                    if (end($ext2) == "mp3") {
                        $audio = $ext2[0] . $last_id . '_' . $user_id . '.' . end($ext2);
                        $half_path2 = "files/users/user_" . $user_id . "/social/posts/files/" . $audio;
                        $path2 = $_SERVER['DOCUMENT_ROOT'] . "/files/users/user_" . $user_id . "/social/posts/files/" . $audio;
                        $tmp2 = $_FILES['audio']['tmp_name'];

                        if (move_uploaded_file($tmp2, $path2)) {
                            $query3 = "INSERT INTO `social_files` (`id`, `user_id`, `object_id`, `object_type`, `url`, `type`) 
                        VALUES (NULL, '$user_id', '$last_id', 'post', '$half_path2', 'audio')";
                            $run3 = mysqli_query($conn, $query3);
                        }
                    }
                }
                echo "uploaded";
            }
        } else {
            echo "Access Forbidden";
        }
    }
}
