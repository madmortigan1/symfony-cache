<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Contracts\Cache\ItemInterface;
use Symfony\Contracts\Cache\TagAwareCacheInterface;

class DefaultController extends AbstractController
{
    /**
     * @Route("/default", name="default")
     */
    public function index(TagAwareCacheInterface $redisCache): Response
    {
        $value = $redisCache->get('foo.bar.baz', function(ItemInterface $item) {
            $item->tag(['foo']);
            $item->expiresAfter(5);

            return 'value '.time();
        });

        return $this->json([
            'value' => $value,
        ]);
    }
}
