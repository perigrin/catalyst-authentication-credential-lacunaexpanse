package Catalyst::Authentication::Credential::LacunaExpanse;
use Moose;
use Try::Tiny;
use namespace::autoclean;

has '_config' => ( isa => 'HashRef', is => 'ro', );
has 'realm' => ( isa => 'Catalyst::Authentication::Realm', is => 'ro', );

sub BUILDARGS {
    my ( $class, $config, $app, $realm ) = @_;
    return { _config => $config, realm => $realm };
}

sub authenticate {
    my ( $self, $c, $realm, $authinfo ) = @_;
    $c->log->debug('Attempting to log into Lacuna Expanse');
    return try {
        $c->model('Expanse')->get_client($authinfo)->assert_session;
        return $realm->find_user($authinfo);
    }
    catch { $c->log->debug("Login Failed: $_"); return; };
}

1;
__END__
