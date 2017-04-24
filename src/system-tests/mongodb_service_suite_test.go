package mongodb_service_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestMongoDBService(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "MongoDB Service Suite")
}
