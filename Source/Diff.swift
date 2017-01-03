import Foundation

public struct Diff<T: Collection> where T.Index == IndexSet.Element, T.IndexDistance == IndexSet.Element
{
    public let source: T
    public let destination: T
    
    public let inserted: IndexSet
    public let deleted: IndexSet
    public let movements: Set<Match>
    public let equalMatches: Set<Match>
    public let changes: Set<Match>
    
    public init(from source: T, to destination: T) {
        self.source = source
        self.destination = destination
        
        if source.count == 0 && destination.count > 0 { // Everything added
            self.inserted = IndexSet(integersIn: 0..<destination.count)
            self.deleted = IndexSet()
            self.movements = Set<Match>()
            self.equalMatches = Set<Match>()
            self.changes = Set<Match>()
            return
        }
        
        if source.count > 0 && destination.count == 0 { // Everything deleted
            self.inserted = IndexSet()
            self.deleted = IndexSet(integersIn: 0..<source.count)
            self.movements = Set<Match>()
            self.equalMatches = Set<Match>()
            self.changes = Set<Match>()
            return
        }
        
        // Make normal calculations
        var availableDestinationIndexes = IndexSet(integersIn: 0..<destination.count)
        var positiveMatches = Set<Match>()
        var equalMatches = Set<Match>()
        var changes = Set<Match>()
        var deleted = IndexSet()
        
        // Scan match from source to destination
        for (sourceIndex, sourceElement) in source.enumerated() {
            if let sourceElement = sourceElement as? Matchable {
                let match = Diff.match(for: sourceElement, at: sourceIndex, in: destination)
                
                switch match {
                case .change(_, let destination):
                    availableDestinationIndexes.remove(destination)
                    changes.insert(match)
                    positiveMatches.insert(match)
                case .equal(_, let destination):
                    availableDestinationIndexes.remove(destination)
                    equalMatches.insert(match)
                    positiveMatches.insert(match)
                case .none:
                    deleted.insert(sourceIndex)
                } // switch
            } // if sourceElement is Matchable
        } // for source
        
        // Every index without a match from source is an inserted index
        self.inserted = availableDestinationIndexes
        availableDestinationIndexes.removeAll()
        
        // Find movements inside positive matches
        self.movements = Diff.movements(in: positiveMatches, with: inserted, deleted)
        
        self.deleted = deleted
        self.equalMatches = equalMatches
        self.changes = changes
    } // init
    
    private static func match(for element: Matchable, at index: T.Index, in destination: T) -> Match
    {
        for destinationElement in destination {
            let match = element.match(with: destinationElement)
            
            switch match {
            case .equal, .change:
                return match
            case .none:
                break
            } // switch
        } // for destination
        
        return Match.none(source: index)
    }

    private static func movements(in matches: Set<Match>, with inserted: IndexSet, _ deleted: IndexSet) -> Set<Match>
    {
        var movements = Set<Match>()
        
        for match in matches {
            switch match {
            case .equal(let source, let destination) where source != destination,
                 .change(let source, let destination) where source != destination:
                let offset = sourceOffset(for: match, in: movements, with: inserted, deleted)
                if source + offset != destination {
                    movements.insert(match)
                }
            default:
                break // Do nothing
            } // switch
        } // for
        
        return movements
    }
    
    private static func sourceOffset(for movement: Match, in movements: Set<Match>, with inserted: IndexSet, _ deleted: IndexSet) -> Int
    {
        let insertionsBefore = inserted.count(in: 0..<movement.destination!)
        let deletionsBefore = deleted.count(in: 0..<movement.source)
        
        var offset = insertionsBefore - deletionsBefore
        for anotherMovement in movements {
            if movement != anotherMovement, anotherMovement.source < movement.source, anotherMovement.destination! > movement.destination!
            {
                offset = offset - 1 // A preceding item is now after
            } // if
            
            // Movements with anotherMovement.source > movement.source are discarded
            // because they are considered future movements
        } // for
        
        return offset
    }
}
