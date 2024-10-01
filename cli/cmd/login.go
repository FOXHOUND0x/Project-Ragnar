/*
Copyright © 2024 FOXHOUND0x foxhound@the0x.dev
*/
package cmd

import (
	"context"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types"
	"github.com/spf13/cobra"
	"golang.org/x/term"
)

var (
	username   string
	password   string
	userPoolID string
	clientID   string
)

var loginCmd = &cobra.Command{
	Use:   "login",
	Short: "Logins into AWS cognito to get a token via PKCE",
	Long: `Logins into AWS cognito to get a token via PKCE in order
	to authenticate with the AWS API Gateway.`,
	Run: func(cmd *cobra.Command, args []string) {
		if username == "" {
			fmt.Printf("Enter Username: ")
			fmt.Scanln(&username)
		}
		if password == "" {
			fmt.Printf("Enter Password: ")
			fmt.Scanln(&password)
			bytePassword, _ := term.ReadPassword(int(os.Stdin.Fd()))
			password = string(bytePassword)
		}

		_, err := cognitoAuth(username, password)
		if err != nil {
			fmt.Printf("Authentication failed: %v\n:", err)
			return
		}

		fmt.Println("Successfully Authenticated")

	},
}

func cognitoAuth(username, password string) (string, error) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		return "", fmt.Errorf("failed to load default AWS configuration from ~/.aws/config: %w", err)
	}

	cognitoClient := cognitoidentityprovider.NewFromConfig(cfg)
	if userPoolID == "" {
		fmt.Printf("Enter User Pool ID: ")
		fmt.Scanln(&userPoolID)
	}
	if clientID == "" {
		fmt.Printf("Enter Client ID: ")
		fmt.Scanln(&clientID)
	}

	if userPoolID == "" || clientID == "" {
		return "", fmt.Errorf("user pool id or client id is empty")
	}

	authInput := &cognitoidentityprovider.InitiateAuthInput{
		AuthFlow: types.AuthFlowTypeUserPasswordAuth,
		AuthParameters: map[string]string{
			"USERNAME": username,
			"PASSWORD": password,
		},
		ClientId: aws.String(clientID),
	}

	authOutput, err := cognitoClient.InitiateAuth(context.TODO(), authInput)
	if err != nil {
		return "", fmt.Errorf("auth failed: %w", err)
	}

	if authOutput.AuthenticationResult == nil || authOutput.AuthenticationResult.IdToken == nil {
		return "", fmt.Errorf("token is null")
	}

	return *authOutput.AuthenticationResult.IdToken, nil
}

func init() {
	rootCmd.AddCommand(loginCmd)

	loginCmd.Flags().StringVarP(&username, "username", "u", "", "Username for Cognito")
	loginCmd.Flags().StringVarP(&password, "password", "p", "", "Password for Cognito")

	userPoolID = os.Getenv("AWS_COGNITO_USER_POOL_ID")
	clientID = os.Getenv("AWS_COGNITO_CLIENT_ID")

	loginCmd.Flags().StringVar(&userPoolID, "user-pool-id", userPoolID, "AWS Cognito User Pool ID")
	loginCmd.Flags().StringVar(&clientID, "client-id", clientID, "AWS Cognito Client ID")
}
