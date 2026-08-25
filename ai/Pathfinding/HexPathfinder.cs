using System;
using System.Collections.Generic;

namespace Sovereigns.AI.Pathfinding
{
    public struct HexNode : IEquatable<HexNode>
    {
        public int Q { get; }
        public int R { get; }

        public HexNode(int q, int r)
        {
            Q = q;
            R = r;
        }

        public int DistanceTo(HexNode other)
        {
            int s1 = -Q - R;
            int s2 = -other.Q - other.R;
            return (Math.Abs(Q - other.Q) + Math.Abs(R - other.R) + Math.Abs(s1 - s2)) / 2;
        }

        public bool Equals(HexNode other) => Q == other.Q && R == other.R;
        public override bool Equals(object? obj) => obj is HexNode other && Equals(other);
        public override int GetHashCode() => HashCode.Combine(Q, R);
    }

    public class HexPathfinder
    {
        private static readonly (int dQ, int dR)[] Directions = new[]
        {
            (1, 0), (1, -1), (0, -1), (-1, 0), (-1, 1), (0, 1)
        };

        public static List<HexNode> FindPath(HexNode start, HexNode goal, Func<HexNode, int> getCost, Func<HexNode, bool> isPassable)
        {
            var openSet = new PriorityQueue<HexNode, int>();
            var cameFrom = new Dictionary<HexNode, HexNode>();
            var gScore = new Dictionary<HexNode, int> { [start] = 0 };

            openSet.Enqueue(start, 0);

            while (openSet.Count > 0)
            {
                var current = openSet.Dequeue();

                if (current.Equals(goal))
                {
                    return ReconstructPath(cameFrom, current);
                }

                foreach (var dir in Directions)
                {
                    var neighbor = new HexNode(current.Q + dir.dQ, current.R + dir.dR);

                    if (!isPassable(neighbor))
                        continue;

                    int cost = getCost(neighbor);
                    int tentativeGScore = gScore[current] + cost;

                    if (!gScore.ContainsKey(neighbor) || tentativeGScore < gScore[neighbor])
                    {
                        cameFrom[neighbor] = current;
                        gScore[neighbor] = tentativeGScore;
                        int fScore = tentativeGScore + neighbor.DistanceTo(goal);
                        openSet.Enqueue(neighbor, fScore);
                    }
                }
            }

            return new List<HexNode>(); // Path not found
        }

        private static List<HexNode> ReconstructPath(Dictionary<HexNode, HexNode> cameFrom, HexNode current)
        {
            var totalPath = new List<HexNode> { current };
            while (cameFrom.ContainsKey(current))
            {
                current = cameFrom[current];
                totalPath.Add(current);
            }
            totalPath.Reverse();
            return totalPath;
        }
    }
}
