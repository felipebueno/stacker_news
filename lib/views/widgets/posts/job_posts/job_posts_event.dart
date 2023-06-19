part of 'job_posts_bloc.dart';

abstract class JobPostsEvent extends Equatable {
  const JobPostsEvent();
}

class GetJobPosts extends JobPostsEvent {
  const GetJobPosts();

  @override
  List<Object> get props => [];
}

class GetMoreJobPosts extends JobPostsEvent {
  const GetMoreJobPosts();

  @override
  List<Object> get props => [];
}
