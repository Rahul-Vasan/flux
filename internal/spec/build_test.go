package spec_test

import (
	"context"
	"testing"
	"time"

	"github.com/influxdata/flux/dependencies/dependenciestest"
	"github.com/influxdata/flux/dependency"
	_ "github.com/influxdata/flux/fluxinit/static"
	"github.com/influxdata/flux/internal/spec"
	"github.com/influxdata/flux/runtime"
)

func Benchmark_FromScript(b *testing.B) {
	query := `
import "influxdata/influxdb/monitor"
// Disable to the call to to since that isn't enabled
// in the flux repository.
option monitor.write = (tables=<-) => tables
check = from(bucket: "telegraf")
	|> range(start: -5m)
	|> mean()
	|> monitor.check(
		data: {tags: {}, _type: "default", _check_id: 101, _check_name: "test"},
		crit: (r) => r._value > 90,
		messageFn: (r) => "${r._value} is greater than 90",
	)
	|> monitor.stateChanges(toLevel: "crit")

// Multiple yield calls to the same table object so that
// we check whether we have a duplicate table object node
// to exercise that piece of code.
check |> yield(name: "checkResult")
check |> yield(name: "mean")
`
	ctx, deps := dependency.Inject(context.Background(), dependenciestest.Default())
	defer deps.Finish()

	b.ReportAllocs()
	for i := 0; i < b.N; i++ {
		if _, err := spec.FromScript(ctx, runtime.Default, time.Now(), query); err != nil {
			b.Fatal(err)
		}
	}
}
