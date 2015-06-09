Aws.add_service(:AutoScaling, {
  api: File.join(Aws::API_DIR, 'autoscaling', '2011-01-01', 'api-2.json'),
  docs: File.join(Aws::API_DIR, 'autoscaling', '2011-01-01', 'docs-2.json'),
  paginators: File.join(Aws::API_DIR, 'autoscaling', '2011-01-01', 'paginators-1.json'),
  resources: File.join(Cloudat::Aws::API_DIR, 'Autoscaling.resources.json')
})
