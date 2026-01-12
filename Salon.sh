#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n ~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  SERVICES=$($PSQL "SELECT service_id, name FROM services;")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME Service"
  done
  
  read SERVICE_ID_SELECTED
  
  # Check if service exists
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  
  if [[ -z $SERVICE_NAME ]]
  then
    # Service doesn't exist, show menu again
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    # Service exists, get customer info
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    
    # Check if customer exists
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    
    if [[ -z $CUSTOMER_NAME ]]
    then
      # New customer, get name
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      
      # Insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    fi
    
    # Clean up service name and customer name (remove leading/trailing spaces)
    SERVICE_NAME_TRIMMED=$(echo $SERVICE_NAME | sed 's/^ *| *$//')
    CUSTOMER_NAME_TRIMMED=$(echo $CUSTOMER_NAME | sed 's/^ *| *$//')
    
    # Get appointment time
    echo -e "\nWhat time would you like your $SERVICE_NAME_TRIMMED, $CUSTOMER_NAME_TRIMMED?"
    read SERVICE_TIME
    
    # Get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    
    # Insert appointment
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    
    if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a $SERVICE_NAME_TRIMMED at $SERVICE_TIME, $CUSTOMER_NAME_TRIMMED."
    fi
  fi
}

MAIN_MENU
exit
