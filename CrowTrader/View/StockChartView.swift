import SwiftUI
import Charts

struct StockChartView: View {
    let data: ChartData
    @State private var selectedPrice: Double?
    
    
    var body: some View {
        let chartPoints: [ChartPoint] = data.chartPoints
        let priceRange: (min: Double, max: Double) = data.priceRange
        Chart {
            ForEach(chartPoints) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Price", point.price)
                )
                .interpolationMethod(.cardinal)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.8),
                            Color.green.opacity(0.6)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            
            AreaMark(
                x: .value("Date", chartPoints.first?.date ?? Date()),
                yStart: .value("Min", priceRange.min),
                yEnd: .value("Price", chartPoints.first?.price ?? 0)
            )
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.green.opacity(0.3),
                        Color.green.opacity(0.1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color.gray.opacity(0.3))
                AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color.gray.opacity(0.3))
                AxisValueLabel()
                    .foregroundStyle(Color.gray)
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color.gray.opacity(0.3))
                AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color.gray.opacity(0.3))
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self) {
                        Text("\(Int(doubleValue))")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .chartYScale(domain: priceRange.min...priceRange.max)
        .frame(height: 300)
        .background(Color.black)
    }
}


#Preview {
    // Sample data for preview
    let sampleData = ChartData(chart: ChartQuote(result: [
        ChartResult(
            timestamp: [1736121600,1736121660,1736121720,1736121780,1736121840,1736121900,1736121960,1736122020,1736122080,1736122140,1736122200,1736122260,1736122320,1736122380,1736122440,1736122500,1736122560,1736122620,1736122680,1736122740],
            indicators: Indicators(quote: [
                Quote(
                    close: [150.0, 155.0, 152.0],
                    high: [152.0, 156.0, 154.0],
                    open: [149.0, 151.0, 155.0],
                    low: [148.0, 150.0, 151.0],
                    volume: [1000000, 1200000, 900000]
                )
            ])
        )
    ]))
    
    return StockChartView(data: sampleData)
        .preferredColorScheme(.dark)
}
