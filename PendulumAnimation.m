
function OutputImpl(world)
    % Set actor properties at a specified simulation step
    if world.UserData.Step < numel(world.UserData.theta)
        angle = world.UserData.theta(world.UserData.Step);
        world.Actors.moving_pivot.Rotation = [0 0 angle];
    end
    world.UserData.Step = world.UserData.Step + 1;
end 

world = sim3d.World('Output',@OutputImpl);

l = 0.1;
bob_width = 0.03;
t = out.theta_simulated.Time;
theta_sim = -out.theta_simulated.Data;

sampletime = 0.01;
stoptime = 15;

pivot_box = sim3d.Actor(ActorName='pivot_box', Mobility=sim3d.utils.MobilityTypes.Stationary);
createShape(pivot_box,'box',[0.01 1 1]);
pivot_box.PreciseContacts = true;
pivot_box.Translation = [1 0 0];
pivot_box.Rotation = [0 0 0];
add(world,pivot_box); 

pivot = sim3d.Actor(ActorName='pivot', Mobility=sim3d.utils.MobilityTypes.Movable);
createShape(pivot,'cylinder', [0.01,0.01,0.03]);
add(world, pivot, pivot_box);
pivot.Rotation = [0 pi/2 0];
pivot.Translation = [0 0 0];
pivot.Color = [1 0 0];

moving_pivot = sim3d.Actor(ActorName='moving_pivot', Mobility=sim3d.utils.MobilityTypes.Movable);
createShape(moving_pivot,'cylinder', [0.015,0.015,0.03]);
add(world, moving_pivot, pivot);
moving_pivot.Rotation = [0 0 theta_sim(1)];
moving_pivot.Color = [1 0 0];

rod = sim3d.Actor(ActorName='rod', Mobility=sim3d.utils.MobilityTypes.Movable);
createShape(rod,'cylinder', [0.01,0.01,l]);
add(world, rod, moving_pivot);
rod.Translation = [-l/2 0 0.01];
rod.Rotation = [0 pi/2 0];
rod.Color = [0 1 0];

bob = sim3d.Actor(ActorName='bob', Mobility=sim3d.utils.MobilityTypes.Movable);
createShape(bob,'cylinder',[bob_width,bob_width,0.03])
add(world,bob,rod);
bob.Translation = [0 0 l/2];
bob.Rotation = [0 pi/2 0];
bob.Color = [0 0 1];

measurement1 = sim3d.graphics.Text( ...
    ActorName = "measurement1", ...
    Translation = [0.99 0 0.51], ...
    String = "1 m", ...
    FontSize = 0.1, ...
    Color = [0 0 1]);   % blue

measurement2 = sim3d.graphics.Text( ...
    ActorName = "measurement2", ...
    Translation = [0.99 0.51 0], ...
    String = "1 m", ...
    FontSize = 0.1, ...
    Color = [0 0 1]);   % blue

add(world, measurement1);
add(world, measurement2);

viewport = createViewport(world);
viewport.Translation = [0 0 0];
viewport.Rotation = [0 0 0];

world.UserData.Step = 2;
world.UserData.dt = sampletime;
world.UserData.theta = theta_sim;
run(world,sampletime,stoptime)
delete(world);



