import boto3
import datetime

def lambda_handler(event, context):
    ce = boto3.client('ce')
    
    # Get the current month
    now = datetime.datetime.now()
    start_date_current = f"{now.year}-{now.month}-01"
    if now.month == 1:
        start_date_prev = f"{now.year-1}-12-01"
    else:
        start_date_prev = f"{now.year}-{now.month-1}-01"
    
    # Assuming the lambda runs at the end of the month, so we set end_date to now
    end_date = f"{now.year}-{now.month}-{now.day}"
    
    # Fetch costs for the previous month
    results_prev = ce.get_cost_and_usage(
        TimePeriod={'Start': start_date_prev, 'End': start_date_current},
        Granularity='MONTHLY',
        Metrics=['BlendedCost']
    )
    
    # Fetch costs for the current month
    results_current = ce.get_cost_and_usage(
        TimePeriod={'Start': start_date_current, 'End': end_date},
        Granularity='MONTHLY',
        Metrics=['BlendedCost']
    )

    cost_prev = float(results_prev['ResultsByTime'][0]['Total']['BlendedCost']['Amount'])
    cost_current = float(results_current['ResultsByTime'][0]['Total']['BlendedCost']['Amount'])

    # Check if the cost is 10% more than the previous month
    if cost_current > 1.10 * cost_prev:
        # Here you can send this to CloudWatch or take some other action.
        # For this example, we'll just print it.
        print(f"Cost has increased by more than 10%! Previous: ${cost_prev}, Current: ${cost_current}")
    
    return {
        'statusCode': 200,
        'body': "Check complete"
    }