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
