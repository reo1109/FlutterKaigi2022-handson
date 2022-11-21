import 'dart:developer';
import 'package:flutterkaigi/graphql/mutation.dart';
import 'package:flutterkaigi/graphql/query.dart';
import 'package:flutterkaigi/model/issue.dart';
import 'package:flutterkaigi/model/repository.dart';
import 'package:flutterkaigi/plugin/graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<List<Repository>?> fetchRepositories() async {
  var response = await client.query(
    QueryOptions(
      document: gql(repositoriesQuery),
    ),
  );
  final List<dynamic>? results =
  response.data?['viewer']?['repositories']?['nodes'];
  final List<Repository> repositoryList =
  results!.map((dynamic item) => Repository.fromJson(item)).toList();
  return repositoryList;
}

Future<List<Issue>?> fetchIssues() async {
  var response = await client.query(
    QueryOptions(
      document: gql(issuesQuery),
    ),
  );

  final List<dynamic>? results =
  response.data?['repository']?['issues']?['nodes'];
  final List<Issue> issueList =
  results!.map((dynamic item) => Issue.fromJson(item)).toList();
  return issueList;
}

Future<void> createIssue({required String title, required String body}) async {
  final MutationOptions options = MutationOptions(
    document: gql(createMutation),
    variables: <String, dynamic>{
      'titleText': title,
      'bodyText': body,
    },
  );

  final QueryResult result = await client.mutate(options);
  if (result.hasException) {
    log(result.exception.toString());
    return;
  }
}

Future<void> updateIssue(
    {required String id, required String title, required String body}) async {
  final MutationOptions options = MutationOptions(
    document: gql(updateMutation),
    variables: <String, dynamic>{
      'idText': id,
      'titleText': title,
      'bodyText': body,
    },
  );

  final QueryResult result = await client.mutate(options);
  if (result.hasException) {
    log(result.exception.toString());
    return;
  }
}



