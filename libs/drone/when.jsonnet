local droneStatus = ['success', 'failure'];

{
            new():: self + {},
            withBranch(branch):: self + if std.type(branch) == 'array' then { branch: branch } else { branch: [branch] },
            withEvent(e):: self + if std.type(e) == 'array' then { event: e } else { event: [e] },
            withStatus(s):: self + if std.type(s) == 'array' then { status: s } else { status: [s] },
            withStatusAll():: self.withStatus(droneStatus),
}